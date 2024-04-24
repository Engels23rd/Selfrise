const router = require("express").Router();
const chat = require("../services/chat");

router.get("/:id", async (req, res, next) => {
    try {
        const id = req.params.id;
        
        const fetched = await chat.read(id);

        if (fetched)
            res.status(200).json(fetched);
        else
            res.status(404).send("Not Found");
    } catch (err) {
        console.log(`Error while reading from chat: ${err.message}`);
        next(err);
    }
});

module.exports = router;
