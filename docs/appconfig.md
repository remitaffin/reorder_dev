# App config

## Chronotrigger

### Add indexes to mongoDB

```javascript
db.getCollection('one-time-tasks').createIndex({"created": 1})
db.getCollection('one-time-tasks').createIndex({"name": 1}, { unique: true })
db.getCollection('one-time-tasks').createIndex({"run_at": 1}, { expireAfterSeconds: 7776000 })
db.getCollection('one-time-tasks').createIndex({"status": 1, "run_at": 1})
```
