/**
 * Module dependencies.
 */

var mongoose = require('mongoose'),
    config = require('../../config/config.js'),
    Schema = mongoose.Schema;
/**
 *	Recipe Schema
 */
var EventSchema = new Schema({
    starts: {
        type: Date,
        required: true
    },
    ends: {
        type: Date,
        required: true
    },
    location: { // Room number
        type: String,
        required: true,
        trim: true
    },
    chapters: { // Read instructions
        type: String
    }
});

/**
 * Methods
 */
EventSchema.methods.saveToDisk = function(event, callback) {
    event.save(function(err, event) {
        if (err) {
            callback(err, null);
        } else {
            callback(null, event);
        }
    });
};

/**
 * Statics
 */
EventSchema.statics = {

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
        this.find(function(err, Events) {
            if (err) {
                callback(err, undefined);
            }
            callback(undefined, Events);
        });
    }
};

var Event = mongoose.model('Event', EventSchema);
module.exports = {
    Event: Event
};