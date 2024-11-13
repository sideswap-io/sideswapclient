use crate::models;

pub fn handle_http_request(
    agent: &ureq::Agent,
    details: &models::RespAuthUser,
) -> Result<ciborium::value::Value, anyhow::Error> {
    let url = details
        .http_request
        .params
        .urls.first()
        .ok_or_else(|| anyhow!("empty urls array"))?;

    let data = cbor_to_json(details.http_request.params.data.clone())?;
    let data = serde_json::to_string(&data)?;

    let response = agent
        .post(url)
        .set("Content-Type", "application/json")
        .set("Accept", "application/json")
        .send_string(&data)?;
    let response = response.into_string()?;
    let response = serde_json::from_str::<serde_json::Value>(&response)?;

    json_to_cbor(response)
}

fn cbor_to_json(value: ciborium::value::Value) -> Result<serde_json::Value, anyhow::Error> {
    match value {
        ciborium::value::Value::Integer(v) => Ok(serde_json::Value::Number(
            serde_json::Number::from_f64(i128::from(v) as f64)
                .ok_or_else(|| anyhow!("integer number conversion failed"))?,
        )),
        ciborium::value::Value::Float(v) => Ok(serde_json::Value::Number(
            serde_json::Number::from_f64(v)
                .ok_or_else(|| anyhow!("float number conversion failed"))?,
        )),
        ciborium::value::Value::Text(v) => Ok(serde_json::Value::String(v)),
        ciborium::value::Value::Bool(v) => Ok(serde_json::Value::Bool(v)),
        ciborium::value::Value::Null => Ok(serde_json::Value::Null),
        ciborium::value::Value::Array(v) => Ok(serde_json::Value::Array(
            v.into_iter()
                .map(cbor_to_json)
                .collect::<Result<Vec<_>, anyhow::Error>>()?,
        )),
        ciborium::value::Value::Map(v) => Ok(serde_json::Value::Object(
            v.into_iter()
                .map(|(key, value)| {
                    cbor_to_json(value)
                        .map(|value| (key.as_text().unwrap_or_default().to_owned(), value))
                })
                .collect::<Result<serde_json::Map<_, _>, anyhow::Error>>()?,
        )),
        // ciborium::value::Value::Bytes(_) => todo!(),
        _ => bail!("unsupported CBOR value"),
    }
}

fn json_to_cbor(value: serde_json::Value) -> Result<ciborium::value::Value, anyhow::Error> {
    match value {
        serde_json::Value::Null => Ok(ciborium::value::Value::Null),
        serde_json::Value::Bool(v) => Ok(ciborium::value::Value::Bool(v)),
        serde_json::Value::String(v) => Ok(ciborium::value::Value::Text(v)),
        serde_json::Value::Number(v) if v.is_f64() => {
            Ok(ciborium::value::Value::Float(v.as_f64().unwrap()))
        }
        serde_json::Value::Number(v) => bail!("unsupported number: {:?}", v),
        serde_json::Value::Array(v) => Ok(ciborium::value::Value::Array(
            v.into_iter()
                .map(json_to_cbor)
                .collect::<Result<Vec<_>, anyhow::Error>>()?,
        )),
        serde_json::Value::Object(v) => Ok(ciborium::value::Value::Map(
            v.into_iter()
                .map(|(key, value)| {
                    json_to_cbor(value).map(|value| (ciborium::value::Value::Text(key), value))
                })
                .collect::<Result<Vec<_>, anyhow::Error>>()?,
        )),
    }
}
