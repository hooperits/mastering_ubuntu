import os
import yaml
from typing import Dict, Any, List, Optional

class Loader:
    def __init__(self, labs_dir: Optional[str] = None):
        if labs_dir:
            self.labs_dir = labs_dir
        else:
            self.labs_dir = os.path.join(os.path.dirname(__file__), "labs")

    def list_available_labs(self) -> List[Dict[str, Any]]:
        """Scans the labs directory and loads metadata from yaml configs."""
        labs = []
        if not os.path.exists(self.labs_dir):
            return labs

        for entry in os.listdir(self.labs_dir):
            full_path = os.path.join(self.labs_dir, entry)
            if os.path.isdir(full_path):
                config_path = os.path.join(full_path, "lab.yaml")
                if os.path.exists(config_path):
                    try:
                        with open(config_path, "r") as f:
                            metadata = yaml.safe_load(f)
                            if isinstance(metadata, dict):
                                # Ensure ID is always set
                                metadata["id"] = metadata.get("id", entry)
                                labs.append(metadata)
                    except (yaml.YAMLError, OSError):
                        pass
        # Sort labs by ID
        labs.sort(key=lambda x: x.get("id", ""))
        return labs

    def load_lab(self, lab_id: str) -> Optional[Dict[str, Any]]:
        """Loads all assets (config, setup file, verifier, guide) for a given lab ID."""
        lab_path = os.path.join(self.labs_dir, lab_id)
        config_path = os.path.join(lab_path, "lab.yaml")

        if not os.path.exists(config_path):
            # Try to match by scanning to see if yaml's ID matches
            matched_dir = None
            for entry in os.listdir(self.labs_dir):
                candidate_dir = os.path.join(self.labs_dir, entry)
                if os.path.isdir(candidate_dir):
                    candidate_config = os.path.join(candidate_dir, "lab.yaml")
                    if os.path.exists(candidate_config):
                        try:
                            with open(candidate_config, "r") as f:
                                meta = yaml.safe_load(f)
                                if meta and meta.get("id") == lab_id:
                                    matched_dir = candidate_dir
                                    config_path = candidate_config
                                    break
                        except (yaml.YAMLError, OSError):
                            pass
            if matched_dir:
                lab_path = matched_dir
            else:
                return None

        try:
            with open(config_path, "r") as f:
                metadata = yaml.safe_load(f)
        except (yaml.YAMLError, OSError):
            return None

        # Build paths to other files
        setup_script = os.path.join(lab_path, "setup.sh")
        verify_script = os.path.join(lab_path, "verify.sh")
        guide_md = os.path.join(lab_path, "guide.md")

        return {
            "metadata": metadata,
            "directory": lab_path,
            "setup_path": setup_script if os.path.exists(setup_script) else None,
            "verify_path": verify_script if os.path.exists(verify_script) else None,
            "guide_path": guide_md if os.path.exists(guide_md) else None
        }

    def load_hints(self, lab_id: str) -> Optional[List[Dict[str, Any]]]:
        """Loads hints from hints.yaml in the lab directory."""
        lab_data = self.load_lab(lab_id)
        if not lab_data:
            return None
        
        hints_path = os.path.join(lab_data["directory"], "hints.yaml")
        if not os.path.exists(hints_path):
            return None
            
        try:
            with open(hints_path, "r") as f:
                content = yaml.safe_load(f)
                if isinstance(content, dict) and "hints" in content:
                    return content["hints"]
        except (yaml.YAMLError, OSError):
            pass
        return None
