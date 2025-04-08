# Python Google Artworks Parser

This project parses artwork data from HTML pages, extracts relevant information (such as name, extensions, link, and image), and returns the data in a structured JSON format.

## Prerequisites

Make sure you have Python 3.7+ installed on your system, along with `pip` for installing dependencies.

## Setup

1. Clone the repository or download the project files.
2. Navigate to the project directory.

```bash
cd /relative_path/moya_python_solution
```

3. Create a virtual environment (optional but recommended):

```bash
python3 -m venv venv
```

4. Activate the virtual environment:

- On macOS/Linux:

```bash
source venv/bin/activate
```

- On Windows:

```bash
venv\Scripts\activate
```

5. Install the required dependencies from `requirements.txt`:

```bash
pip install -r requirements.txt
```

## Running the Parser

1. Ensure you have the HTML file you want to parse. For example, you can use `van-gogh-paintings.html` or any other HTML file in the `html_files` folder.
   
2. To run the parser and print the output, run the following command:

```bash
python src/parser.py
```

This will execute the script, parse the HTML, and print the resulting JSON data of artworks.

## Running Tests

This project uses `pytest` for unit testing. To run the tests:

1. To run all tests:

```bash
pytest -v
```

This will run the tests defined in `test_parser.py` against all the html files inside html_files/.

## Folder Structure

The project structure is as follows:

```
.
├── README.md               # Project description and instructions
├── html_files              # Directory containing sample HTML files for parsing
│   ├── sample_1.html
│   ├── sample_2.html
│   ├── sample_3.html
│   └── van-gogh-paintings.html  # Example HTML for testing the parser
├── requirements.txt        # List of dependencies for the project
├── src                     # Source code for the parser
│   ├── __init__.py
│   └── parser.py           # The main parsing script
└── tests                   # Unit tests for the parser
    ├── __init__.py
    └── test_parser.py      # Test cases for the parser
```

## Author
Muhammad Owais
Data: 08-April-2025