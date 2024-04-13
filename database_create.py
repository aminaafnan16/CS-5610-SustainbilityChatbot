import sqlite3

# database name is 'shiny_data'
conn = sqlite3.connect('shiny_data')

c = conn.cursor()


#For Creating Table called shiny
# c.execute(""" CREATE TABLE shiny(
#     fullname TEXT NOT NULL,
#     email_signup TEXT,
#     password_signup TEXT,
#     postalcode TEXT,        
# )

# """)
# c.execute("""ALTER TABLE shiny
#              ADD COLUMN phone_number TEXT CHECK(length(phone_number) = 10);""")
conn.commit()
conn.close()