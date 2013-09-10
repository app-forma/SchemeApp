/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
    Helpers = require('../../helpers.js'),
    User = mongoose.model('User');


/**
 * List of users
 */
exports.index = function(req, res) {
  User.list(function(err, users) {
    if (err) return res.json(500, err.errors);
    res.json(200, users);
  });
};

/**
 * Find item by id
 */
exports.user = function(req, res, next, id) {
  User.load(id, function(err, user) {
    if (err) return next(err);
    if (!user) return next(new Error('Failed to load user ' + id));
    req.user = user;
    next();
  });
};

/**
 * Create a user
 */
exports.create = function(req, res) {
  var user = new User(req.body);
  user.password = Helpers.generateCryptoPassword(user.password);
  user.saveToDisk(user, function(err, user) {
    if (err) {
      res.json(500, err.errors);
    } else {
      res.json(200, user);
    }
  });
};

/**
 * Update a user
 */
exports.update = function(req, res) {
  // Obj can't contain _id. Will generate error.
  delete req.body._id;
  User.update({
    _id: req.params.id
  }, req.body, {
    upsert: true
  }, function(err, doc) {
    if (err) {
      res.json(500, err);
    } else {
      res.json(200, doc);
    }
  });
};

/**
 * Delete a user
 */
exports.destroy = function(req, res) {
  User.remove({
    _id: req.params.id
  }, function(err) {
    if (err) {
      res.json(500, err.errors);
    } else {
      res.json(200);
    }
  });
};

/**
* User by id
*/
exports.byId = function(req, res) {
  User.findOne({
    _id: req.params.id
  }).populate('eventWrappers')
  .exec(function(err, doc) {
      if (err) {
        res.json(500, err.errors);
      } else {
        res.json(200, doc);
      }
    });
};

exports.byIdRaw = function(req, res) {
  User.findOne({
    _id: req.params.id
  }).exec(function(err, doc) {
      if (err) {
        res.json(500, err.errors);
      } else {
        res.json(200, doc);
      }
    });
};

/**
*   Compare test to hashed password
*/
exports.comparePasswords = function (password, passwordHash) {
  return Helpers.validateCryptoPassword(password, passwordHash);
};