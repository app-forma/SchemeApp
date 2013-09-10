var mongoose = require('mongoose'),
  Message = mongoose.model('Message');



exports.message = function(req, res, next, id) {
  Message.load(id, function(err, message) {
    if (err) return next(err);
    if (!message) return next(new Error('Failed to load message ' + id));
    req.message = message;
    next();
  });
};



exports.create = function(req, res) {
  var message = new Message(req.body);
  message.saveToDisk(message, function(err, message) {
    if (err) {
      res.json(500, err.errors);
    } else {
      res.json(200, message);
    }
  });
};



exports.update = function(req, res) {
  // Obj can't contain _id. Will generate error.
  delete req.body._id;
  Message.update({
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



exports.destroy = function(req, res) {
  Message.findOne({
    _id: req.params.id
  }, function(err, doc) {
    if (err) {
      res.json(500, err.errors);
    } else {
      doc.remove();
      res.json(200);
    }
  });
};


exports.index = function(req, res) {
  Message.list(function(err, messages) {
    if (err) return res.json(500, err.errors);
    res.json(200, messages);
  });
};

exports.byId = function(req, res) {
  Message.findOne({
    _id: req.params.id
  })//.populate('whatever references needed')
    .exec(function(err, doc) {
      if (err) {
        res.json(404);
        return;
      } else {
        res.json(200, doc);
      }
    });
};