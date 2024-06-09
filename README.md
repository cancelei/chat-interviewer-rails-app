# README

To start the project like you would do in any new rails app.

`bundle install`

Set up .env file with the following:

```
OPENAI_API_KEY=your_openai_api_key
DB_USERNAME=your_db_username
DB_PASSWORD=your_db_password
DB_HOST=your_db_host
```

`rails db:create`

`rails db:migrate`

`redis-server`

`rails s`

Test's were skipped in this project.

Also consider using redis-server for background jobs with good_job gem.