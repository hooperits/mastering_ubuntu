import logging

# Initialize logger
logger = logging.getLogger("u_lab")
logger.setLevel(logging.INFO)

# Handler for stdout/stderr or files can be configured dynamically via CLI
handler = logging.StreamHandler()
formatter = logging.Formatter("%(asctime)s [%(levelname)s] %(name)s: %(message)s")
handler.setFormatter(formatter)
logger.addHandler(handler)
