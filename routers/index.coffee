express = require "express"
router = express.Router()

router
    .get "/", (req, res) ->
        res.render "feedback"

module.exports = router