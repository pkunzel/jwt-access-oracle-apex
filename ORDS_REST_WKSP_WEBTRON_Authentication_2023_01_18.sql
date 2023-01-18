
-- Generated by ORDS REST Data Services 22.4.0.r3531253
-- Schema: WKSP_WEBTRON  Date: Wed Jan 18 12:46:09 2023 
--

BEGIN
  ORDS.ENABLE_SCHEMA(
      p_enabled             => TRUE,
      p_schema              => 'WKSP_WEBTRON',
      p_url_mapping_type    => 'BASE_PATH',
      p_url_mapping_pattern => 'webtron',
      p_auto_rest_auth      => FALSE);
    
  ORDS.DEFINE_MODULE(
      p_module_name    => 'Authentication',
      p_base_path      => '/authentication/',
      p_items_per_page => 25,
      p_status         => 'PUBLISHED',
      p_comments       => NULL);

  ORDS.DEFINE_TEMPLATE(
      p_module_name    => 'Authentication',
      p_pattern        => 'jwt',
      p_priority       => 0,
      p_etag_type      => 'HASH',
      p_etag_query     => NULL,
      p_comments       => NULL);

  ORDS.DEFINE_HANDLER(
      p_module_name    => 'Authentication',
      p_pattern        => 'jwt',
      p_method         => 'POST',
      p_source_type    => 'plsql/block',
      p_mimes_allowed  => NULL,
      p_comments       => NULL,
      p_source         => 
'declare
    -- l_items apex_t_varchar2;
    l_other_claims varchar2(32767);
    l_jwt varchar2(32767);
    l_url varchar2(32767);

    l_body varchar2(32767);
    l_username varchar2(32767);
    l_page varchar2(32767);
    l_base_url varchar2(32767);
begin
    l_base_url := ''https://g851996bb8ecaa8-webtronapex.adb.sa-saopaulo-1.oraclecloudapps.com'';

    l_body := ''{ "name" : "Paulo", "password" : "12345" }'';
    l_username := ''PAULO.KUNZEL'';
    l_page := ''1'';

    -- Removes the JSON outer brackets
    l_other_claims := ltrim(l_body, ''{'');
    l_other_claims := rtrim(l_other_claims, ''}'');

    -- Basic JWT encoding
    l_jwt := apex_jwt.encode(
        p_iss           => ''ORDS Rest API'',
        p_sub           => upper(l_username),
        p_aud           => ''APEX'',
        p_exp_sec       => 300,
        p_other_claims  => l_other_claims,
        p_signature_key => sys.utl_raw.cast_to_raw( ''Secret!123'' )
    );

   -- Creates a Session for APP 100 pag' || 'e 1
    apex_session.create_session(
        p_app_id   => 100,
        p_page_id  => 1,
        p_username => l_username
    );

    -- Get an url passing the JWT into the Global Variable x01
    l_url := apex_page.get_url(
        p_page => l_page,
        p_session => null,
        p_items => ''x01'',
        p_values => l_jwt
    );

    -- Removes the endpoint prefix?
    --l_url := substr(l_url, instr(l_url, ''/r/''));

    -- Removex the checksum from the url.
    l_url := substr(l_url, 1, instr(l_url, ''cs='') -1);

    :url :=  l_base_url || l_url;
end;');

  ORDS.DEFINE_PARAMETER(
      p_module_name        => 'Authentication',
      p_pattern            => 'jwt',
      p_method             => 'POST',
      p_name               => 'url',
      p_bind_variable_name => 'url',
      p_source_type        => 'RESPONSE',
      p_param_type         => 'STRING',
      p_access_method      => 'OUT',
      p_comments           => NULL);

    
        
COMMIT;

END;