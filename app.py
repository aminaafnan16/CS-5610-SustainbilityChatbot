import streamlit as st
from PyPDF2 import PdfReader
from langchain.text_splitter import RecursiveCharacterTextSplitter
import os
from langchain_google_genai import GoogleGenerativeAIEmbeddings
import google.generativeai as genai
#from langchain.vectorstores import FAISS
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.chains.question_answering import load_qa_chain
from langchain.prompts import PromptTemplate
from dotenv import load_dotenv
from PIL import Image

from langchain_community.vectorstores import FAISS

load_dotenv()
os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

def input_image_setup(uploaded_file):
    if uploaded_file is not None:
        bytes_data = uploaded_file.getvalue()
        image_parts=[
            {
                "mime_type": uploaded_file.type,
                "data": bytes_data
            }
        ]
        return image_parts
    else:
        raise FileNotFoundError("No file uploaded")
    
def get_gemini_response(input,image,prompt):
    try:
        model= genai.GenerativeModel('gemini-pro-vision')
        response = model.generate_content([input,image[0],prompt])
        return response.text
    except:
        return 'Trouble encountered while generating response'

def get_pdf_text(pdf_doc):
    text=""
    pdf_reader= PdfReader(pdf_doc)
    for page in pdf_reader.pages:
        text+= page.extract_text()
    return  text

def get_text_chunks(text):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=10000, chunk_overlap=1000)
    chunks = text_splitter.split_text(text)
    return chunks


def get_vector_store(text_chunks):
    embeddings = GoogleGenerativeAIEmbeddings(model = "models/embedding-001")
    vector_store = FAISS.from_texts(text_chunks, embedding=embeddings)
    vector_store.save_local("faiss_index")


def get_conversational_chain():

    prompt_template = """
    Answer the question as detailed as possible from the provided context, make sure to provide all the details, if the answer is not in
    provided context just say, "answer is not available in the context", don't provide the wrong answer\n\n
    Context:\n {context}?\n
    Question: \n{question}\n

    Answer:
    """

    model = ChatGoogleGenerativeAI(model="gemini-pro",
                             temperature=0.3)

    prompt = PromptTemplate(template = prompt_template, input_variables = ["context", "question"])
    chain = load_qa_chain(model, chain_type="stuff", prompt=prompt)

    return chain



def user_input(user_question):
    embeddings = GoogleGenerativeAIEmbeddings(model = "models/embedding-001")
    
    new_db = FAISS.load_local("faiss_index", embeddings,allow_dangerous_deserialization=True)
    docs = new_db.similarity_search(user_question)
    chain = get_conversational_chain()
    
    response = chain(
        {"input_documents":docs, "question": user_question}
        , return_only_outputs=True)

    print(response)
    st.subheader("The Response is")
    st.write("", response["output_text"])

def main():
    st.set_page_config(page_title="Green")
    st.header("Sustainability Bot (draft)")

    # Specify the filename without the directory path
    filename = "One_Big_Text.pdf"
    
    # Assuming the file is located in the same directory as the script
    script_directory = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_directory, filename)
    print("*****************",file_path)
    raw_text = get_pdf_text(file_path)
    text_chunks = get_text_chunks(raw_text)
    get_vector_store(text_chunks)

    with st.form("question_form"):
        user_question = st.text_input("Let me help you with your questions on sustainablity")
        submit_button = st.form_submit_button(label="Generate Response")
    user_input(user_question)

if __name__ == "__main__":
    main()