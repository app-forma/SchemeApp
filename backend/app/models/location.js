/**
 * Module dependencies.
 */

var mongoose = require('mongoose'),
    config = require('../../config/config.js'),
    Schema = mongoose.Schema;
/**
 *	Recipe Schema
 */
var LocationSchema = new Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    latitude: {
        type: Number,
        required: true
    },
    longitude: {
        type: Number,
        required: true
    }
});

/**
 * Methods
 */
LocationSchema.methods.saveToDisk = function (location, callback) {
    location.save(function (err, location) {
        if (err) {
            callback(err, null);
        } else {
            callback(null, location);
        }
    });
};

/**
 * Statics
 */

LocationSchema.statics = {

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
        this.find(function (err, locations) {
            if (err) {
                callback(err, undefined);
            }
            callback(undefined, locations);
        });
    }
};

var Location = mongoose.model('Location', LocationSchema);
module.exports = {
    Location: Location
};