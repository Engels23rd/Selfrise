const router = require("express").Router();
const emotions = require("../services/emotions");

router.get("/:id", async (req, res, next) => {
    try {
        const id = req.params.id;

        const result = await emotions.read(id);

        if (result)
            res.status(200).json(result);
        else
            res.status(404).send("Not Found");
    } catch(err) {
        console.log(`Error while reading emotions: ${err.message}`);
        res.status(500).json(err);
        next(err);
    }
});

module.exports = router;