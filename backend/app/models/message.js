/**
 * Module dependencies.
 */

var mongoose = require('mongoose'),
    config = require('../../config/config.js'),
    EventWrapper = require('./user.js'),
    Schema = mongoose.Schema;


var MessageSchema = new Schema({
    text: {
        type: String,
        required: true,
        trim: true
    },
    date: {
        type: String,
        required: true,
        trim: true
    },
    from: [{ // e.g. this user is registered on following courses
        type: Schema.Types.ObjectId,
        ref: 'User'
    }]
});

/**
 * Methods
 */
MessageSchema.methods.saveToDisk = function(message, callback) {
    message.save(function(err, message) {
        if (err) {
            callback(err, null);
        } else {
            callback(null, message);
        }
    });
};

/**
 * Statics
 */

MessageSchema.statics = {

    load: function(id, callback) {
        this.findOne({
            _id: id
        })
            .populate('_id', 'id')
            .exec(callback);
    },

    /**
     * List
     */
    list: function(callback) {
        this.find(function(err, Messages) {
            if (err) {
                callback(err, undefined);
            }
            callback(undefined, Messages);
        });
    }
};

var Message = mongoose.model('Message', MessageSchema);
module.exports = {
    Message: Message
};