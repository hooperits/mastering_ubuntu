from click.testing import CliRunner
from unittest.mock import patch, MagicMock
from u_lab.cli import cli

@patch("u_lab.cli.Loader")
@patch("u_lab.cli.StateManager")
@patch("u_lab.cli.EngineManager")
def test_cli_list_empty(mock_engine, mock_state, mock_loader):
    # Mock empty catalog
    mock_loader.return_value.list_available_labs.return_value = []
    
    runner = CliRunner()
    result = runner.invoke(cli, ["list"])
    
    assert result.exit_code == 0
    assert "No labs found in the catalog" in result.output

@patch("u_lab.cli.Loader")
@patch("u_lab.cli.StateManager")
@patch("u_lab.cli.EngineManager")
def test_cli_list_with_labs(mock_engine, mock_state, mock_loader):
    # Mock one lab in catalog
    mock_loader.return_value.list_available_labs.return_value = [
        {"id": "01-systemd", "title": "Systemd Service Mastery", "difficulty": "Medium", "estimated_time": "20m"}
    ]
    # Mock progress
    mock_state.return_value.get_lab.return_value = {"status": "Not Started"}
    # Mock running status
    mock_engine.return_value.container_exists.return_value = False
    
    runner = CliRunner()
    result = runner.invoke(cli, ["list"])
    
    assert result.exit_code == 0
    assert "Systemd Service Mastery" in result.output
    assert "01-systemd" in result.output

@patch("u_lab.cli.Loader")
@patch("u_lab.cli.StateManager")
@patch("u_lab.cli.EngineManager")
def test_cli_start_lab_not_found(mock_engine, mock_state, mock_loader):
    mock_loader.return_value.load_lab.return_value = None
    
    runner = CliRunner()
    result = runner.invoke(cli, ["start", "non-existent"])
    
    assert result.exit_code == 1
    assert "not found" in result.output
