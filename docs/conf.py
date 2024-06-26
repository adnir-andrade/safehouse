# Configuration file for the Sphinx documentation builder.

# -- Project information -----------------------------------------------------

project = 'Safehouse'
author = 'Adnir Andrade'
release = '0.3'

# -- General configuration ---------------------------------------------------

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.napoleon',
    'sphinx.ext.viewcode'
]

templates_path = ['_templates']
exclude_patterns = []

# -- Options for HTML output -------------------------------------------------

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
