import json
import os
from datetime import datetime
from typing import Dict, Any, Optional

DEFAULT_STATE_PATH = os.path.expanduser("~/.config/u-lab/progress.json")

class StateManager:
    def __init__(self, filepath: str = DEFAULT_STATE_PATH):
        self.filepath = filepath
        self.data = self._load()

    def _load(self) -> Dict[str, Any]:
        """Loads state from the config file, returning default structure if not found."""
        if not os.path.exists(self.filepath):
            return {"labs": {}}
        
        try:
            with open(self.filepath, "r") as f:
                return json.load(f)
        except (json.JSONDecodeError, OSError):
            # If corrupted, fallback to empty
            return {"labs": {}}

    def save(self) -> None:
        """Saves current state to progress file."""
        os.makedirs(os.path.dirname(self.filepath), exist_ok=True)
        try:
            with open(self.filepath, "w") as f:
                json.dump(self.data, f, indent=2)
        except OSError:
            pass

    def get_lab(self, lab_id: str) -> Dict[str, Any]:
        """Gets a lab's state record, initializing it if absent."""
        if "labs" not in self.data:
            self.data["labs"] = {}
        
        if lab_id not in self.data["labs"]:
            self.data["labs"][lab_id] = {
                "status": "Not Started",
                "started_at": None,
                "completed_at": None,
                "attempts": 0
            }
        return self.data["labs"][lab_id]

    def start_lab(self, lab_id: str) -> None:
        """Marks a lab as started, setting the start timestamp if first run."""
        lab = self.get_lab(lab_id)
        if lab["status"] == "Not Started":
            lab["status"] = "In Progress"
            lab["started_at"] = datetime.utcnow().isoformat() + "Z"
        self.save()

    def complete_lab(self, lab_id: str) -> None:
        """Marks a lab as completed, setting completion timestamp."""
        lab = self.get_lab(lab_id)
        lab["status"] = "Completed"
        lab["completed_at"] = datetime.utcnow().isoformat() + "Z"
        self.save()

    def increment_attempts(self, lab_id: str) -> None:
        """Increments the check attempt counter for a lab."""
        lab = self.get_lab(lab_id)
        lab["attempts"] += 1
        self.save()
