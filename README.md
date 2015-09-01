[![Gem Version](https://badge.fury.io/rb/shareable_models.svg)](http://badge.fury.io/rb/shareable_models) [![Build Status](https://travis-ci.org/redBorder/shareable_models.svg?branch=master)](https://travis-ci.org/redBorder/shareable_models) [![Code Climate](https://codeclimate.com/github/redBorder/shareable_models/badges/gpa.svg)](https://codeclimate.com/github/redBorder/shareable_models) [![Test Coverage](https://codeclimate.com/github/redBorder/shareable_models/badges/coverage.svg)](https://codeclimate.com/github/redBorder/shareable_models/coverage)

# Shareable Models

Shareable models is a gem to share models between models. Is this strange? I will explain the functionality of this Gem with an example.

Imagine you have an awesome Rails app for a publisher with three models:
* Author: it creates books.
* Book: a world behind words.
* Group: a group of authors.

An author can create many private books, but he wants to share it another author. Author class is a `sharer`, it can share and receive books. Books are things that can be shared, so they are `shareable`.

Another author wants to share its book with multiple authors, all of them form a Group. Share a book with all authors in the group can be bored. However, you can set Group `shareable` and share the book with the entire group.

Shareable Models use polymorphic relations to allow you to share resources between multiple models with no limitations.

# Installation
To use `ShareableModels` in your application, add this line to your Gemfile:

```ruby
  gem 'shareable_models', '~> 1.0.0'
```

After add it, run `bundle install`.

Next you need to load migrations of this gem, so execute in your Rails application:

```
rake shareable_models:install:migrations
rake db:migrate
```

Last step is to set your classes as `sharer` or `shareable`. To do this include these methods at top of yout models. For example:

```ruby
# File app/models/author.rb (sharer)
class Author < ActiveRecord::Base
  sharer

  #...
end

# File app/models/book.rb (shareable)
class Book < ActiveRecord::Base
  # Owner define the creator of the book, to check edit/read permissions.
  # See next sections
  shareable owner: :author

  #...
end
```

# Models
A model can be `sharer` or `shareable`. This methods include some relations and add new methods to your class.

## Sharer
Set a model as sharer. A sharer can share and receive resources. It has edit permissions on a resource if:

* It creates the resource (see [Shareable](#shareable))
* Another sharer shares the resource with him and edit permission is true.

Importants methods defined by sharer (see [sharer.rb](https://github.com/redBorder/shareable_models/blob/master/lib/shareable_models/models/sharer.rb) for full documentation):

* `share(resource, to, edit)`: share a resource with another model (to). You can set edit permissions (false by default).
* `share_with_me(resource, from, edit)`: share a resource **from** another sharer to me. 
* `can_edit?(resource)`: check if a model can edit a resource.
* `can_read?(resource)`: check if a model can read a resource.
* `throw_out(resource, sharer)`: throw out a sharer from a resource.
* `leave(resource)`: to leave resource. A creator/owner of a shareable resource can't leave it.
* `allow_edit?(resource, to)`: allow a model to edit a resource. If resource was never shared with model, a new relation is created.
* `prevent_edit?(resource, to)`: disable an user to edit a resource. If resource was never shared with model, relation won't be created.

## Shareable
Set a model as shareable. You need to specify what's the name of the relation to find 'owner' or 'creator' of this shareable model:
```ruby
class User < ActiveRecord::Base
  shareable owner: :user
  # ...
end
```

Shareable models can be shared between sharers. Importants methods defined by sharer (see [shareable.rb](https://github.com/redBorder/shareable_models/blob/master/lib/shareable_models/models/shareable.rb) for full documentation):

* `share_it(from, to, edit)`: share the resource with **from** a model **to** another. You can set edit permissions (false by default).
* `editable_by?(from)`: check if resource is editable by given model.
* `readable_by?(from)`: check if resource is readable by given model.
* `throw_out(from, to)`: a sharer (**from**) throw out another (**to**) from a resource.
* `leave(sharer)`: sharer leaves resource. A creator/owner of a shareable resource can't leave it.
* `allow_edit?(from, to)`: a sharer (**from**) allow another (**to**) to edit a resource. If resource was never shared with model, a new relation is created.
* `prevent_edit?(from, to)`: a sharer (**from**) disable another (**to**) to edit a resource. If resource was never shared with model, relation won't be created.

# Example of usage

```ruby
# We start at scenario described at introduction: Author, Book and Group. Instanced models:
# * author1: it creates book1
# * author2: another author. Anyone shared book1 with it.

author1.can_read? book1         # -> true
author1.can_edit? book1         # -> true
author2.can_read? book1         # -> false
author2.can_edit? book1         # -> false

author1.share(book1, author2)   # -> true
author2.can_read? book1         # -> true
author2.can_edit? book1         # -> false

author1.allow_edit(book1, author2)    # -> true
author2.can_read? book1               # -> true
author2.can_edit? book1               # -> true
```

# Contribute

To contribute Shareable Models:

* Create an issue with the contribution: bug, enhancement, feature...
* Fork the repository and make all changes you need
* Write test on new changes
* Create a pull request when you finish

# License

ShareableModels gem is released under the Affero GPL license. Copyright [redBorder](http://redborder.net)
