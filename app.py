from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import os


_DATABASEUSER = "root"
_DATABASEPASS = "aptx4869+-"


class Config:
    SQLALCHEMY_TRACK_MODIFICATIONS = True
    SQLALCHEMY_DATABASE_URI = "mysql+pymysql://" + _DATABASEUSER + ":" + _DATABASEPASS + \
                              "@sh-cdb-oc7jg1nt.sql.tencentcdb.com:63192/hack?charset=utf8"


app = Flask(__name__)
app.config.from_object(Config)
db = SQLAlchemy()
db.init_app(app)


class ProductModel(db.Model):
    __tablename__ = "products"
    id_ = db.Column(db.Integer, primary_key=True)
    step_id = db.Column(db.Integer, index=True, nullable=False)
    product_id = db.Column(db.Integer, index=True, nullable=False)
    item_id = db.Column(db.Integer, nullable=False, index=True)
    item_name = db.Column(db.String(255), nullable=False)
    content = db.Column(db.Text, nullable=False)
    time_cost = db.Column(db.Integer, nullable=False, default=0)

    def to_dict(self):
        return {
            "id": self.id_,
            "step_id": self.step_id,
            "product_id": self.product_id,
            "content": self.content,
            "time_cost": self.time_cost,
            "item_id": self.item_id,
            "item_name": self.item_name
        }


@app.route("/prompt", methods=["GET"])
def prompt():
    _product_id = request.args.get("product_id")
    _step_id = request.args.get("step_id")
    data = ProductModel.query.filter_by(
        product_id=_product_id, step_id=_step_id).first()
    if not data:
        return jsonify({})
    return jsonify(data.to_dict())


if __name__ == "__main__":
    app.run("0.0.0.0")
