/**
 * Module dependencies.
 */

var mongoose = require('mongoose'),
    config = require('../../config/config.js'),
    EventWrapper = require('./eventWrapper.js'),
    Schema = mongoose.Schema;
/**
 *	Recipe Schema
 */
var EventSchema = new Schema({
    room: { // Room number
        type: String,
        required: true,
        trim: true
    },
    info: { // Read instructions
        type: String
    },
    startDate: {
        type: String,
        required: true
    },
    endDate: {
        type: String,
        required: true
    },
    _eventWrapperId: {
        type: Schema.Types.ObjectId,
        ref: 'EventWrapper'
    }


});

/**
 * Methods
 */
EventSchema.methods.saveToDisk = function (event, callback) {
    event.save(function (err, event) {
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

    load: function (id, callback) {
        this.findOne({
            _id: id
        })
            .populate('_id', 'id')
            .exec(callback);
    },

    /**
     * List
     */
    list: function (callback) {
        this.find(function (err, Events) {
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