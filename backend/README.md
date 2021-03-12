# Endpoints

## User Service

  1. `GET /users/:username/:password`
      - request:
        - HTTP header: 
          ```
          "Content-Type": "application/json"
          ``` 
        - request body:
          ```
          username: $USERNAME:STRING 
          password: $PASSWORD:STRING
          ```
      - response:
        - Succeed:
          ```
          {
            id: $ID:STRING,
            firstName: $FIRSTNAME:STRING,
            lastName: $LASTNAME:STRING,
            username: $USERNAME:STRING,
            password: $PASSWORD:STRING,
            date: $DATE:STRING
          }
          ```
  2. `POST /users/:id/:firstName/:lastName/:username/:password/:date`
      - request:
        - HTTP header: 
          ```
          "Content-Type": "application/json"
          ``` 
        - request body:
          ```
          id: $ID:STRING,
          firstName: $FIRSTNAME:STRING,
          lastName: $LASTNAME:STRING,
          username: $USERNAME:STRING,
          password: $PASSWORD:STRING,
          date: $DATE:STRING
          ```
     
     
     
