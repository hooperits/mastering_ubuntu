import os
import sys
import click
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich.markdown import Markdown

from u_lab.loader import Loader
from u_lab.state import StateManager
from u_lab.engine import EngineManager

console = Console()

@click.group()
def cli():
    """Labyrinth: The Interactive Ubuntu Server Lab Engine."""
    pass

@cli.command("list")
def list_labs():
    """List all available learning labs and progress."""
    try:
        loader = Loader()
        state = StateManager()
        engine = EngineManager()
        
        labs = loader.list_available_labs()
        if not labs:
            console.print("[yellow]No labs found in the catalog.[/yellow]")
            return

        table = Table(title="Ubuntu Server Mastery Lab Catalog", show_header=True, header_style="bold magenta")
        table.add_column("Lab ID", style="cyan", width=12)
        table.add_column("Title", style="white", min_width=25)
        table.add_column("Difficulty", style="yellow")
        table.add_column("Est. Time", style="blue")
        table.add_column("Status", style="green")
        table.add_column("Running", style="red")

        for lab in labs:
            lab_id = lab.get("id", "")
            title = lab.get("title", "Untitled")
            difficulty = lab.get("difficulty", "Medium")
            est_time = lab.get("estimated_time", "15m")
            
            # Fetch status
            progress = state.get_lab(lab_id)
            status = progress.get("status", "Not Started")
            
            if status == "Completed":
                status_str = "[bold green]✓ Completed[/bold green]"
            elif status == "In Progress":
                status_str = "[bold yellow]⏳ In Progress[/bold yellow]"
            else:
                status_str = "[dim white]Not Started[/dim white]"

            # Check if active running container exists
            container_name = f"u-lab-{lab_id}"
            is_running = "[bold red]Yes[/bold red]" if engine.container_exists(container_name) else "[dim white]No[/dim white]"

            table.add_row(lab_id, title, difficulty, est_time, status_str, is_running)

        console.print(table)
    except Exception as e:
        console.print(f"[red]Error: {e}[/red]")
        sys.exit(1)

@cli.command("start")
@click.argument("lab_id")
def start_lab(lab_id):
    """Start an Ubuntu lab container environment."""
    try:
        loader = Loader()
        state = StateManager()
        engine = EngineManager()

        lab_data = loader.load_lab(lab_id)
        if not lab_data:
            console.print(f"[red]Error: Lab with ID '{lab_id}' not found.[/red]")
            sys.exit(1)

        console.print(Panel(
            f"[bold green]Starting Ubuntu Lab Environment:[/bold green] [bold white]{lab_data['metadata'].get('title')}[/bold white]\n"
            f"[dim]Please wait while we prepare the container sandbox...[/dim]",
            border_style="green"
        ))

        # Launch the container (handles building base image and running setup)
        engine.start_container(lab_id, lab_data)
        
        # Mark as In Progress in state
        state.start_lab(lab_id)

        # Print guide markdown if it exists
        guide_path = lab_data.get("guide_path")
        if guide_path and os.path.exists(guide_path):
            with open(guide_path, "r") as f:
                md_content = f.read()
            console.print("\n" + "="*80)
            console.print(Markdown(md_content))
            console.print("="*80 + "\n")

        console.print(Panel(
            f"[bold green]Lab sandbox environment is ready![/bold green]\n\n"
            f"1. Run [bold cyan]u-lab attach {lab_id}[/bold cyan] to connect to the terminal.\n"
            f"2. Solve the objectives in the guide above.\n"
            f"3. Run [bold cyan]u-lab check {lab_id}[/bold cyan] to verify your config.\n"
            f"4. Run [bold cyan]u-lab destroy {lab_id}[/bold cyan] to clean up resources.",
            border_style="cyan"
        ))
    except Exception as e:
        console.print(f"[red]Error during startup: {e}[/red]")
        sys.exit(1)

@cli.command("attach")
@click.argument("lab_id")
def attach_lab(lab_id):
    """Enter the lab's interactive terminal."""
    try:
        engine = EngineManager()
        engine.attach_container(lab_id)
    except Exception as e:
        console.print(f"[red]Error attaching: {e}[/red]")
        sys.exit(1)

@cli.command("check")
@click.argument("lab_id")
def check_lab(lab_id):
    """Check configuration and verify lab completion."""
    try:
        loader = Loader()
        state = StateManager()
        engine = EngineManager()

        lab_data = loader.load_lab(lab_id)
        if not lab_data:
            console.print(f"[red]Error: Lab with ID '{lab_id}' not found.[/red]")
            sys.exit(1)

        console.print(f"Running automated audits on [bold cyan]{lab_id}[/bold cyan] container...")
        
        # Increment attempt counter
        state.increment_attempts(lab_id)
        
        # Run test scripts inside container
        passed, test_output = engine.verify_lab(lab_id, lab_data)
        
        # Render the verifier's terminal logs
        console.print("\n[bold]Audit Log output:[/bold]")
        console.print("-" * 50)
        console.print(test_output.strip())
        console.print("-" * 50 + "\n")

        if passed:
            state.complete_lab(lab_id)
            console.print(Panel(
                f"🎉 [bold green]CONGRATULATIONS! ALL CHECKS PASSED![/bold green] 🎉\n\n"
                f"You have proven proficiency in [bold white]{lab_data['metadata'].get('title')}[/bold white].\n"
                f"Progress updated. Run [bold cyan]u-lab list[/bold cyan] to see updated records.",
                border_style="green",
                expand=False
            ))
        else:
            console.print(Panel(
                f"❌ [bold red]VERIFICATION FAILED[/bold red] ❌\n\n"
                f"Some state checks did not pass. Read the Audit Log output above for clues.\n"
                f"Keep editing the configuration inside the container and run check again when ready.",
                border_style="red",
                expand=False
            ))
            sys.exit(1)
    except Exception as e:
        console.print(f"[red]Error during check: {e}[/red]")
        sys.exit(1)

@cli.command("destroy")
@click.argument("lab_id")
def destroy_lab(lab_id):
    """Clean up and delete the lab container."""
    try:
        engine = EngineManager()
        destroyed = engine.destroy_container(lab_id)
        if destroyed:
            console.print(f"[green]Successfully stopped and removed container 'u-lab-{lab_id}'.[/green]")
        else:
            console.print(f"[yellow]No active container found for '{lab_id}'. Already cleaned up.[/yellow]")
    except Exception as e:
        console.print(f"[red]Error during cleanup: {e}[/red]")
        sys.exit(1)

@cli.command("hint")
@click.argument("lab_id")
def hint_lab(lab_id):
    """Get progressive hints for a lab."""
    try:
        loader = Loader()
        state = StateManager()

        lab_data = loader.load_lab(lab_id)
        if not lab_data:
            console.print(f"[red]Error: Lab with ID '{lab_id}' not found.[/red]")
            sys.exit(1)

        hints = loader.load_hints(lab_id)
        if not hints:
            console.print(f"[yellow]No hints configured for lab '{lab_id}'. Please refer to the solution guide at: {lab_data.get('guide_path')}[/yellow]")
            return

        # Fetch current hint level
        hint_level = state.get_hint_level(lab_id)

        if hint_level < len(hints):
            hint = hints[hint_level]
            tier = hint.get("tier", hint_level + 1)
            title = hint.get("title", f"Hint Tier {tier}")
            content = hint.get("content", "")

            console.print(Panel(
                f"[bold yellow]{title}[/bold yellow] (Tier {tier} of {len(hints)})\n\n"
                f"{content}",
                border_style="yellow",
                title=f"Labyrinth Hint System: {lab_data['metadata'].get('title')}",
                expand=False
            ))
            
            # Increment and save
            state.increment_hint_level(lab_id)
            
            # Print next instructions
            if hint_level + 1 < len(hints):
                console.print(f"[dim]Run 'u-lab hint {lab_id}' again to unlock the next hint (Tier {tier + 1}).[/dim]")
            else:
                console.print(f"[dim]All hints unlocked. If you are still stuck, consult the walkthrough guide in the directory: {lab_data.get('guide_path')}[/dim]")
        else:
            console.print(Panel(
                f"[bold yellow]All Hints Unlocked[/bold yellow]\n\n"
                f"You have already seen all {len(hints)} hints.\n"
                f"Check the solutions guide here:\n"
                f"[bold white]{lab_data.get('guide_path')}[/bold white]",
                border_style="yellow",
                expand=False
            ))
    except Exception as e:
        console.print(f"[red]Error fetching hint: {e}[/red]")
        sys.exit(1)

if __name__ == "__main__":
    cli()
