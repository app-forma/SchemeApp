/**
 * Module dependencies.
 */

var mongoose = require('mongoose'),
    config = require('../../config/config.js'),
    EventWrapper = require('./eventWrapper.js'),
    Message = require('./message.js'),
    Schema = mongoose.Schema;
/**
 *	Recipe Schema
 */
var UserSchema = new Schema({
    firstname: {
        type: String,
        required: true,
        trim: true
    },
    lastname: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        required: true,
        trim: true
    },
    password: {
        type: String,
        required: true
    },
    role: {
        type: String,
        required: true,
        trim: true
    },
    eventWrappers: [{ // e.g. this user is registered on following courses
        type: Schema.Types.ObjectId,
        ref: 'EventWrapper'
    }],
    attendances: [String]
});

/**
 * Methods
 */
UserSchema.methods.saveToDisk = function(user, callback) {
    user.save(function(err, user) {
        if (err) {
            callback(err, null);
        } else {
            callback(null, user);
        }
    });
};

/**
 * Statics
 */

UserSchema.statics = {

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
        this.find(function(err, Users) {
            if (err) {
                callback(err, undefined);
            }
            callback(undefined, Users);
        });
    }
};

var User = mongoose.model('User', UserSchema);
module.exports = {
    User: User
};