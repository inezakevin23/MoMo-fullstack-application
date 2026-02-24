# MoMo-fullstack-application

## Team Name
code bros

## Team Members
- Ineza Kevin
- Ishami Irené
- Lincoln Keza Batsinduka

## Project Description
This project processes Mobile Money (MoMo) SMS messages provided in XML format.
The system parses, cleans, categorizes, and stores transaction data in a relational database, then visualizes data through a web-based dashboard.

## project Architecture
Architecture diagram illustrating data flow from XML input to database and dashboard:
**Architecture Diagram Link:**
https://miro.com/app/board/uXjVGRm7DUU=/?passwordless_invite

## Scrum Board
We use an Agile Scrum board to manage tasks and collaboration.
**Scrum Board Link:**
https://github.com/users/inezakevin23/projects/1

## Entity-Relationship Diagram (ERD) design rationale
We have created five entities, which are: 
1. transaction entity
2. transaction category entity
3. users entity
4. roles entity
5. system logs entity

## CRUD operations

We created the database while using basic CRUD operations to maintain correctness and integrity. which were:
- CREATE
- READ
- UPDATE
- DELETE

We added CHECK (transaction_fee >= 0), CHECK (transferred_amount > 0), CHECK (sender_id != receiver_id), to enhance accuracy by preventing invalid transaction values, and also preventing the user from being both sender and receiver in one transaction.

## JSON representations

We not only create relational databases, but we also create the JSON presentation. To maintain integrity and correctness, we base our approach on the entity we have seen above. To not confuse the view, we have uploaded the documentation, which has Mapping between SQL and JSON representation to maintain clarity between bthe SQLdatabase to JSON presentation.
## API 

### Data parsing

This is the way of transforming data from .xml to .json format. This was done for APIs for API implementation to be easier.
The results were stored inthe  dsa/ directory with python script as well as the XML to be transformed. To do so, just run the python3 script named xml_parsing_script.py.

## API implementation

We have created an API with 5 endpoints: 
- GET
- PUT
- DELETE
- POST
- Unauthorized

All the endpoints involved are in the report file.

## Data Structures and Algorithm

This is also in the dsa/ directory, which contains to way which is: linear search and dictionary lookup. Their difference is stated in the report document
the Python script in text.py 

## Database design documentation
[https://drive.google.com/file/d/1GPienfvz1MDUrHC3-7yAh3QEjwvgSUX5/view?usp=sharing](https://drive.google.com/file/d/1GPienfvz1MDUrHC3-7yAh3QEjwvgSUX5/view?usp=sharing)
