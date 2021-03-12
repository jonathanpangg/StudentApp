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
