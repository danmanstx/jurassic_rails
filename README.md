# jurassic_rails
It's 1993 and you're the lead software developer for the new Jurassic Park! Park operations needs a system to keep track of the different cages around the park and the different dinosaurs in each one. You'll need to develop a JSON formatted RESTful API to allow the builders to create new cages. It will also allow doctors and scientists the ability to edit/retrieve the statuses of dinosaurs and cages.

## Requirements
- [x] All requests should respond with the correct HTTP status codes and a response, if necessary, representing either the success or error conditions.
- [x] Data should be persisted using some flavor of SQL.
- [x] Each dinosaur must have a name.

  presence validation on `name`

- [x] Each dinosaur is considered an herbivore or a carnivore, depending on its species.

  * enum on `species` table to hold values `:herbivore :carnivore`

- [x] Carnivores can only be in a cage with other dinosaurs of the same species.

  * validation `carnivore_species_only` on cages, using `validates_associated :cage` when creating a dino

- [x] Each dinosaur must have a species (See enumerated list below, feel free to add others).

  * `species` has a validation on `dinosaur`

- [x] Herbivores cannot be in the same cage as carnivores.
- [x] Use Carnivore dinosaurs like Tyrannosaurus, Velociraptor, Spinosaurus and Megalosaurus.
- [x] Use Herbivores like Brachiosaurus, Stegosaurus, Ankylosaurus and Triceratops.

  * these example dinos are included with the `seed` file

## technical requirements
- [x] This project should be done in Ruby on Rails 6 or newer.
- [x] This should be done using version control, preferably git.
- [x] The project should include a README that addresses anything you may not have completed. It should also address what additional changes you might need to make if the application were intended to run in a concurrent environment.

### Bonus
- [x] Cages have a maximum capacity for how many dinosaurs it can hold.

  * `Cage` has a `capacity` column to specify the max for each `cage`,
  validation `occupancy` enforces this.

- [x] Cages know how many dinosaurs are contained.

  * `dinosaurs_count` is a column on each cage to track how many dinos are in there.

- [x] Cages have a power status of ACTIVE or DOWN.

  * `enum` was used to track `power_status` and uses `:down, :active`

- [x] Cages cannot be powered off if they contain dinosaurs.

  * validation `power_off_dino_check`

- [x] Dinosaurs cannot be moved into a cage that is powered down.

  * validation `power_off_dino_check`

- [x] Must be able to query a listing of dinosaurs in a specific cage.

  * endpoint for listing of dinos in a cage `/api/v1/cage/:cage_id/dinosaurs`

- [x] When querying dinosaurs or cages they should be filterable on their attributes (Cages on their  power status and dinosaurs on species).

  * index endpoints like `/api/v1/dinosaurs` and `/api/v1/cages` are filterable on `power_status` and `species` params

- [x] Automated tests that ensure the business logic implemented is correct.

  * model and request specs added using `rspec`

### additional functionality

- [x] Added `expanded` param to see `dinousaur` info on `cage#index` endpoint, and `species` info on `dinosaur#index` enpoints

- [x] custom endpoints for `power_off` `power_on` for `cages` ie. `/api/v1/cage/2/power_off`


### original boilerplate setup
`rails _6.1.7.3_ new jurassic-rails-api --api --database=postgresql -T`

added `'rspec-rails'`

ran `rails g rspec:install`

ran boilerplate for models

`rails g model Cage name:string capacity:integer power_status:integer`

`rails g model Dinosaur name:string species:references cage:references`

`rails g model Species name:string diet:integer`

### setup and running
`rails db:create`

`rails db:migrate`

`rails db:seed`

`rails s`

### testing
`RAILS_ENV=test bundle exec rspec spec`

if any issues can reset test db with following

`RAILS_ENV=test rails db:reset`

or even more hardcore

`RAILS_ENV=test rails db:drop`
`RAILS_ENV=test rails db:create`
`RAILS_ENV=test rails db:migrate`
`RAILS_ENV=test rails db:seed`

## Concurrency Discussion
Concurrency is a Rails app can be complicated and there are multiple ways to get some improvements.

First, this app being strongly tied to `postgresql`, there would be wins using a connections pooler. Either the builtin rails one, tuned properly. Or even more so, something like `pgbouncer`. These work by keeping a pool of connections to `postgresql` open and save you the startup cost for a new connection. Which allows for a lot of client connections even though `postgresql` only has a few database connections on its side. Next, having `postgresql` live on it's own machine and consider something like read-write replicas would also decouple the app and database.

Second, even though this sample app doesn't have any extensive processes or jobs. Offloading work to a background job system like `sidekiq` could allow you to quickly return requests, and let long running processes or something like a `mailer` be queued up and ran seperately. Similarly, you'd be better of running it in it's own space, be it a container, pod, or server. `Sidekiq` benefits by the number of threads you can run so higher treadcount leads to greater throughput.

Third, scaling and tuning a web server like `puma` just so you get greater concurrency with each web request. `WEB_CONCURRENCY` and `MAX_THREADS` are some basic configurations to play around with. Additionally, adding multiple web servers with a load balancer like `nginx` would allow for even greater concurrency and allow you to scale to needs.

Fourth, from an app level, basic caching techniques could be used. especially for data like `species` that isn't likely to change. This would help save calls to `postgresql` and likely implement in using its own `redis` server. Again, like `postgresql`, you'd want to use something like the gem `connection_pool` so you can make sure you have available connections for each web request. Also from an app level, something like `Optimistic Locking` could come into play if multiple people were editing the same `cage` or `dinosaur`. This technique would provide a way to tell if data had become stale, and allow a resuce to either retry or bail on the update. If we think there is a high probability of locking to occur we can use `Pessimistic Locking` which holds the object until the request is done.
