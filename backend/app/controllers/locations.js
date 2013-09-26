/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Helpers = require('../../helpers.js'),
  Location = mongoose.model('Location'),
  passport = require('passport');


/**
 * List of locations
 */
exports.index = function (req, res) {
  Location.list(function (err, locations) {
    if (err) return res.json(500, err.errors);
    res.json(200, locations);
  });
};

/**
 * Location by id
 */
exports.byId = function (req, res) {
  Location.findOne({
    _id: req.params.id
  }).exec(function (err, doc) {
    if (err) {
      res.json(500, err.errors);
    } else {
      res.json(200, doc);
    }
  });
};

exports.create = function (req, res) {
  var location = new Location(req.body);
  location.saveToDisk(location, function (err, location) {
    if (err) {
      console.log(err);
      res.json(500, err.errors);
    } else {
      console.log(location);
      res.json(200, location);
    }
  });
};


/**
 * Find item by id
 */
exports.location = function (req, res, next, id) {
  Location.load(id, function (err, location) {
    if (err) return next(err);
    if (!location) return next(new Error('Failed to load location ' + id));
    req.location = location;
    next();
  });
};


/**
 * Update a location
 */
exports.update = function (req, res) {
    // Obj can't contain _id. Will generate error.
    delete req.body._id;
    Location.update({
        _id: req.params.id
    }, req.body, {
        upsert: true
    }, function (err, doc) {
        if (err) {
            res.json(500, err);
        } else {
            Location.findOne({
                _id: req.params.id
            }).exec(function(err, doc) {
                    if(err) {
                        res.json(500, err.errors);
                    } else {
                        res.json(200, doc);
                    }
                });
        }
    });
};

/**
 * Delete a location
 */
exports.destroy = function (req, res) {
  Location.remove({
    _id: req.params.id
  }, function (err) {
    if (err) {
      res.json(500, err.errors);
    } else {
      res.json(200, { "deleted": true });
    }
  });
};
