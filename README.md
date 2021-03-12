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
          
  3. `PUT /users/:id/:newDate`
      - request:
        - HTTP header: 
          ```
          "Content-Type": "application/json"
          ``` 
        - request body:
          ```
          id: $ID:STRING,
          newDate: $NEWDATE:STRING
          ```   
     
## Activity Service

  1. `GET /Activity/:id/:date`
      - request:
        - HTTP header: 
          ```
          "Content-Type": "application/json"
          ``` 
        - request body:
          ```
          id: $ID:STRING 
          date: $DATE:STRING
          ```
      - response:
        - Succeed:
          ```
          {
            id: $ID:STRING,
            date: $DATE:STRING,
            activity: $ACTIVITY:[STRING],
            completion: $COMPLETION:[BOOL],
            completionPercentage: $COMPLETIONPERCENTAGE:DOUBLE
          }
          ```
     
  2. `POST /Activity/:id/:date/:activity/:completion/:completionPercentage`
      - request:
        - HTTP header: 
          ```
          "Content-Type": "application/json"
          ``` 
        - request body:
          ```
          id: $ID:STRING,
          date: $DATE:STRING,
          activity: $ACTIVITY:[STRING],
          completion: $COMPLETION:[BOOL],
          completionPercentage: $COMPLETIONPERCENTAGE:DOUBLE
          ```   
        
  3. `DELETE /Activity/:id/:date`
      - request:
        - HTTP header: 
          ```
          "Content-Type": "application/json"
          ``` 
        - request body:
          ```
          id: $ID:STRING,
          date: $DATE:STRING
          ```         
