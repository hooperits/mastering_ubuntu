from setuptools import setup, find_packages

setup(
    name="u-lab",
    version="0.1.0",
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        "click",
        "docker",
        "pyyaml",
        "rich",
    ],
    entry_points={
        "console_scripts": [
            "u-lab=u_lab.cli:cli",
        ],
    },
)
