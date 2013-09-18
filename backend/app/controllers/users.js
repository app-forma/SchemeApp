/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Helpers = require('../../helpers.js'),
  User = mongoose.model('User'),
  EventWrapper = mongoose.model('EventWrapper'),
  passport = require('passport');


/**
 * List of users
 */
exports.index = function (req, res) {
  User.list(function (err, users) {
    if (err) return res.json(500, err.errors);
    res.json(200, users);
  });
};

/**
 * Find item by id
 */
exports.user = function (req, res, next, id) {
  User.load(id, function (err, user) {
    if (err) return next(err);
    if (!user) return next(new Error('Failed to load user ' + id));
    req.user = user;
    next();
  });
};

exports.create = function (req, res) {
  console.log(req.body);
  var user = new User(req.body);
  if (typeof req.body.password === 'string') {
    user.password = Helpers.generateCryptoPassword(user.password);
    user.saveToDisk(user, function (err, user) {
      if (err) {
        console.log(err);
        res.json(500, err.errors);
      } else {
        console.log(err);
        console.log(user);
        res.json(200, user);
      }
    });
  } else {
    res.json(500);
  }
};


/**
 * Update a user
 */
exports.update = function (req, res) {
  // Obj can't contain _id. Will generate error.
  delete req.body._id;
  User.update({
    _id: req.params.id
  }, req.body, {
    upsert: true
  }, function (err, doc) {
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
exports.destroy = function (req, res) {
  User.remove({
    _id: req.params.id
  }, function (err) {
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
exports.byId = function (req, res) {
  User.findOne({
    _id: req.params.id
  }).populate('eventWrappers').populate('messages')
    .exec(function (err, doc) {
      if (err) {
        res.json(500, err.errors);
      } else {
        res.json(200, doc);
      }
    });
};

exports.byIdRaw = function (req, res) {
  User.findOne({
    _id: req.params.id
  }).exec(function (err, doc) {
    if (err) {
      res.json(500, err.errors);
    } else {
      res.json(200, doc);
    }
  });
};

exports.byEmail = function (req, res) {
  User.findOne({
    email: req.params.email
  }).populate('messages').populate('eventWrappers')
    .exec(function (err, doc) {
      if (err) {
        res.json(500, err.errors);
      } else {
        var eventWrappers = [];
        if (doc !== null) {
        doc.eventWrappers.forEach(function (value, entry) {
          eventWrappers.push(value._id);
        });
        EventWrapper.find({
          _id: {
            $in: eventWrappers
          }
        }).populate('owner').populate('events').exec(function (e, d) {
          if (e) {
            res.json(500, e.errors);
          } else {
            doc.eventWrappers = d;
            res.json(200, doc);
          }
        });
      }else {
        res.json(404);
      }
      }
    });
};

/**
 *   Compare test to hashed password
 */
exports.comparePasswords = function (password, passwordHash) {
  return Helpers.validateCryptoPassword(password, passwordHash);
};

/**
 *   Authentication
 */
exports.login = function (req, res, next) {
  user = req.body;
  user.username = req.body.email;
  passport.authenticate('local', function (err, user, info) {
    if (err) {
      return next(err)
    }
    if (!user) {
      req.session.messages = [info.message];
      return res.send(401);
    }
    req.logIn(user, function (err) {
      if (err) {
        return next(err);
      }
      return res.send(200);
    });
  })(req, res, next);
};

exports.logout = function (req, res) {
  req.logout();
  res.send(200);
};