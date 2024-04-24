const router = require("express").Router();
const users = require("../services/users");

router.get("/:id", async function (req, res, next) {
    const id = req.params.id

    const result = await users.read(id);

    if (result) {
        res.status(200).json(result);
    } else {
        res.status(404).json({ msg: "El usuario no existe." })
    }
});

router.patch("/:id", async function (req, res, next) {
    try {
        const id = req.params.id;
        const data = req.body;

        const { user } = await users.read(id);
        if (!user)
            res.status(404).json({ msg: "The user couldn't be found." });
        const newUser = { ...user, ...data };

        res.status(204).json(await users.update(newUser));
    } catch (err) {
        console.error("Error while updating use: " + err.message);
        next(err);
    }
});

router.post('/signup', async (req, res, next) => {
    try {
        const data = req.body;

        const result = await users.create(data);

        res.status(201).json(result);
    } catch (err) {
        res.status(404).json(err);
        console.error("Error while creating user: " + err.message);
        next(err);
    }
});

router.post('/login', async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const { authenticated } = await users.authenticate({ email, password });

        console.log(`route: ${authenticated}`);
        console.log(`route: ${JSON.stringify(authenticated)}`);

        if (authenticated) {
            res.status(200).json({ message: "Usuario autenticado." });
        } else {
            res.status(404).json({ message: "Credenciales invalidas." });
        }
    } catch (err) {
        res.status(500).json(err);
        next(err);
    }
});

router.post('/check-email', (req, res) => {
    const { email } = req.body;

    db.query('SELECT * FROM usuarios WHERE correo = ?', [email], (err, results) => {
        if (err) {
            console.error('Error al verificar correo: ' + err.stack);
            res.status(500).json({ message: 'Error interno del servidor al verificar correo' });
            return;
        }

        if (results.length > 0) {
            res.status(200).json({ exists: true, message: 'El correo ya está registrado' });
        } else {
            res.status(200).json({ exists: false, message: 'El correo no está registrado' });
        }
    });
});

module.exports = router;