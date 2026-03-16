# Contract and Compatibility Rules

1. Existing external field names must not be renamed without explicit contract change approval.
2. Existing field semantics must not change silently.
3. New fields must be backward compatible.
4. Existing SOAP, JAX-RS, or integration payloads must remain compatible unless explicitly versioned.
5. Legacy clients must be assumed sensitive to payload and behaviour changes.
