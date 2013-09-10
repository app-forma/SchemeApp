/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Event = mongoose.model('Event');


/**
 * List of events
 */
exports.index = function(req, res) {
  User.list(function(err, events) {
    if (err) return res.json(500, err.errors);
    res.json(200, events);
  });
};

/**
 * Find event by id
 */
exports.event = function(req, res, next, id) {
  Event.load(id, function(err, event) {
    if (err) return next(err);
    if (!event) return next(new Error('Failed to load event ' + id));
    req.event = event;
    next();
  });
};

/**
 * Create a event
 */
exports.create = function(req, res) {
  var event = new Event(req.body);
  event.saveToDisk(event, function(err, event) {
    if (err) {
      res.json(500, err.errors);
    } else {
      res.json(200, event);
    }
  });
};

/**
 * Update a event
 */
exports.update = function(req, res) {
  // Obj can't contain _id. Will generate error.
  delete req.body._id;
  Event.update({
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
 * Delete a event
 */
exports.destroy = function(req, res) {
  Event.remove({
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
* Event by id
*/
exports.byId = function(req, res) {
  Event.findOne({
    _id: req.params.id
  }).exec(function(err, doc) {
      if (err) {
        res.json(500, err.errors);
      } else {
        res.json(200, doc);
      }
    });
};