/*jslint node: true, plusplus: true, vars: true, maxerr: 200, regexp: true, white: true */

var mongoose = require('mongoose'),
    User = mongoose.model('User'),
    Message = mongoose.model('Message');


function respondPopulatedMessageWithId(_id, res) {
    Message.findOne({
        _id: _id
    }).populate('from')
        .exec(function (err, message) {
            if (err) {
                res.json(404);
            } else {
                res.json(200, message);
            }
        });
}

exports.message = function (req, res, next, id) {
    Message.load(id, function (err, message) {
        if (err) return next(err);
        if (!message) return next(new Error('Failed to load message ' + id));
        req.message = message;
        next();
    });
};

exports.create = function (req, res) {
    var message = new Message(req.body);
    message.saveToDisk(message, function (err, message) {
        if (err) {
            res.json(500, err.errors);
        } else {
            respondPopulatedMessageWithId(message._id, res);
        }
    });
};

exports.update = function (req, res) {
    // Obj can't contain _id. Will generate error.
    delete req.body._id;
    Message.update({
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

exports.destroy = function (req, res) {
    Message.findOne({
        _id: req.params.id
    }, function (err, doc) {
        if (err) {
            res.json(500, err.errors);
        } else {
            doc.remove();
            res.json(200);
        }
    });
};

exports.removeReceiver = function (req, res) {
    Message.findOne({
        _id: req.params.id
    }, function (err, message) {
        if (err) {
            res.json(500, err.errors);
        } else {
            for (var i = message.receivers.length - 1; i >= 0; i--) {
                if (req.params.receiverID == message.receivers[i]) {
                    message.receivers.splice(i, 1);
                    break;
                }
            }
            if (message.receivers.length > 0) {
                message.save(function (err, message) {
                    if (err) {
                        res.json(500, err.errors);
                    } else {
                        res.json(200, message);
                    }
                });
            } else {
                message.remove();
                res.json(200);
            }
        }
    });
};



exports.index = function (req, res) {
    Message.list(function (err, messages) {
        if (err) return res.json(500, err.errors);
        res.json(200, messages);
    });
};

exports.byId = function (req, res) {
    respondPopulatedMessageWithId(req.params.id, res);
};

exports.forUser = function (req, res) {
    Message.find({
        "receivers": {
            $in: [req.params.id]
        }
    }).populate('from').exec(function (err, docs) {
        if (err) {
            res.json(500, err.errors);
        } else {
            res.json(200, docs);
        }
    });
};

exports.byIdRaw = function (req, res) {
    Message.findOne({
        _id: req.params.id
    }).exec(function (err, doc) {
        if (err) {
            res.json(500, err.errors);
        } else {
            res.json(200, doc);
        }
    });
};

exports.broadcast = function (req, res) {
    req.body.receivers = [];
    User.find({
        'role': 'student'
    }, function (err, users) {
        users.forEach(function (user) {
            req.body.receivers.push(user._id);
        });
        console.log(req.body);
        var message = new Message(req.body);
        message.saveToDisk(message, function (err, message) {
            respondPopulatedMessageWithId(message._id, res);
        });
    });
};