from flask import Flask, render_template, request
import os

app = Flask(__name__)

# Define the folder to store uploaded files
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload_file():
    if request.method == 'POST':
        # Check if the POST request has the file part
        if 'file' not in request.files:
            return 'No file part'
        
        file = request.files['file']
        
        # If the user does not select a file, the browser submits an empty file without a filename
        if file.filename == '':
            return 'No selected file'
        
        if file:
            # Save the uploaded file to the specified folder
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], file.filename))
            return 'File successfully uploaded'

if __name__ == '__main__':
    # Ensure the 'uploads' folder exists
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)
    
    app.run(debug=True)
