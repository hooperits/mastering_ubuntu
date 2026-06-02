import os
import tempfile
import yaml
import pytest
from unittest.mock import MagicMock, patch

from u_lab.state import StateManager
from u_lab.loader import Loader
from u_lab.engine import EngineManager

def test_state_manager_default():
    with tempfile.TemporaryDirectory() as tmpdir:
        state_file = os.path.join(tmpdir, "progress.json")
        sm = StateManager(filepath=state_file)
        
        # Test default load
        assert sm.data == {"labs": {}}
        
        # Test get_lab initialization
        lab = sm.get_lab("lab-test")
        assert lab["status"] == "Not Started"
        assert lab["attempts"] == 0
        
        # Test start
        sm.start_lab("lab-test")
        assert sm.get_lab("lab-test")["status"] == "In Progress"
        assert sm.get_lab("lab-test")["started_at"] is not None
        
        # Test completion
        sm.complete_lab("lab-test")
        assert sm.get_lab("lab-test")["status"] == "Completed"
        assert sm.get_lab("lab-test")["completed_at"] is not None

def test_loader_list_labs():
    with tempfile.TemporaryDirectory() as tmpdir:
        # Create a dummy lab folder
        lab_dir = os.path.join(tmpdir, "lab-01")
        os.makedirs(lab_dir)
        
        lab_yaml = {
            "id": "lab-01",
            "title": "Test Lab",
            "difficulty": "Easy",
            "estimated_time": "10m",
            "container": {
                "image": "ubuntu:latest"
            }
        }
        
        with open(os.path.join(lab_dir, "lab.yaml"), "w") as f:
            yaml.dump(lab_yaml, f)
            
        loader = Loader(labs_dir=tmpdir)
        labs = loader.list_available_labs()
        
        assert len(labs) == 1
        assert labs[0]["id"] == "lab-01"
        assert labs[0]["title"] == "Test Lab"

def test_loader_load_lab():
    with tempfile.TemporaryDirectory() as tmpdir:
        lab_dir = os.path.join(tmpdir, "lab-01")
        os.makedirs(lab_dir)
        
        # Write files
        with open(os.path.join(lab_dir, "lab.yaml"), "w") as f:
            yaml.dump({"id": "lab-01", "title": "Test Lab"}, f)
        with open(os.path.join(lab_dir, "setup.sh"), "w") as f:
            f.write("# setup")
        with open(os.path.join(lab_dir, "verify.sh"), "w") as f:
            f.write("# verify")
        with open(os.path.join(lab_dir, "guide.md"), "w") as f:
            f.write("# guide")
            
        loader = Loader(labs_dir=tmpdir)
        lab_data = loader.load_lab("lab-01")
        
        assert lab_data is not None
        assert lab_data["metadata"]["id"] == "lab-01"
        assert lab_data["setup_path"] == os.path.join(lab_dir, "setup.sh")
        assert lab_data["verify_path"] == os.path.join(lab_dir, "verify.sh")
        assert lab_data["guide_path"] == os.path.join(lab_dir, "guide.md")

@patch("docker.from_env")
def test_engine_docker_status(mock_from_env):
    # Mock ping successful
    mock_client = MagicMock()
    mock_from_env.return_value = mock_client
    
    engine = EngineManager()
    assert engine.is_docker_active() is True
    
    # Mock ping failed
    mock_client.ping.side_effect = Exception("offline")
    assert engine.is_docker_active() is False

def test_state_manager_hints():
    with tempfile.TemporaryDirectory() as tmpdir:
        state_file = os.path.join(tmpdir, "progress.json")
        sm = StateManager(filepath=state_file)
        
        # Default hint level is 0
        assert sm.get_hint_level("01-systemd") == 0
        
        # Increment returns new level 1
        assert sm.increment_hint_level("01-systemd") == 1
        assert sm.get_hint_level("01-systemd") == 1

def test_loader_hints():
    with tempfile.TemporaryDirectory() as tmpdir:
        lab_dir = os.path.join(tmpdir, "lab-01")
        os.makedirs(lab_dir)
        
        # Write config and hints file
        with open(os.path.join(lab_dir, "lab.yaml"), "w") as f:
            yaml.dump({"id": "lab-01", "title": "Test Lab"}, f)
        
        hints_data = {
            "hints": [
                {"tier": 1, "title": "Test Title", "content": "Test Content"}
            ]
        }
        with open(os.path.join(lab_dir, "hints.yaml"), "w") as f:
            yaml.dump(hints_data, f)
            
        loader = Loader(labs_dir=tmpdir)
        hints = loader.load_hints("lab-01")
        
        assert hints is not None
        assert len(hints) == 1
        assert hints[0]["title"] == "Test Title"
