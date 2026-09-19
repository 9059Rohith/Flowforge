//! Minimal local `.env` loading for the single-binary CLI/server.
//!
//! Deployment environments should inject variables directly. For local development, reading
//! a gitignored `.env` keeps the documented setup reproducible without adding a runtime crate.

use std::path::Path;

use anyhow::{Context, Result};

/// Load `.env` from the current directory when present. Existing process variables always win.
pub fn load_dotenv() -> Result<()> {
    let path = Path::new(".env");
    if !path.is_file() {
        return Ok(());
    }
    let contents = std::fs::read_to_string(path).context("reading local .env")?;
    for line in contents.lines() {
        if let Some((key, value)) = parse_line(line) {
            if std::env::var_os(&key).is_none() {
                // The file is explicitly local and gitignored; values never enter logs or
                // generated artifacts through this loader.
                std::env::set_var(key, value);
            }
        }
    }
    Ok(())
}

fn parse_line(line: &str) -> Option<(String, String)> {
    let line = line.trim();
    if line.is_empty() || line.starts_with('#') {
        return None;
    }
    let line = line.strip_prefix("export ").unwrap_or(line).trim();
    let (key, raw_value) = line.split_once('=')?;
    let key = key.trim();
    if key.is_empty()
        || !key.chars().enumerate().all(|(i, c)| {
            c == '_' || c.is_ascii_alphanumeric() && (i > 0 || c.is_ascii_alphabetic())
        })
    {
        return None;
    }
    let value = raw_value.trim();
    let value = value
        .strip_prefix('"')
        .and_then(|v| v.strip_suffix('"'))
        .or_else(|| value.strip_prefix('\'').and_then(|v| v.strip_suffix('\'')))
        .unwrap_or(value)
        .to_string();
    Some((key.to_string(), value))
}

#[cfg(test)]
mod tests {
    use super::parse_line;

    #[test]
    fn parses_comments_exports_and_quotes() {
        assert_eq!(parse_line("# ignored"), None);
        assert_eq!(
            parse_line("export OPENFAB_LLM=groq"),
            Some(("OPENFAB_LLM".into(), "groq".into()))
        );
        assert_eq!(
            parse_line("GROQ_API_KEY='secret'"),
            Some(("GROQ_API_KEY".into(), "secret".into()))
        );
    }

    #[test]
    fn rejects_invalid_keys() {
        assert_eq!(parse_line("not-a-key=value"), None);
        assert_eq!(parse_line("=missing"), None);
    }
}
