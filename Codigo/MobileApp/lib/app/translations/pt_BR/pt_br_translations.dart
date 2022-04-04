final _appBarTitles = {
  'supplier_account_title': 'Sua Conta',
  'delivery_list_title': 'Lista de Ofertas',
  'delivery_details': 'Detalhes da Oferta',
};

final _headers = {
  'delivery_code_form_header':
      'Você possui um código para realizar uma entrega?',
  'phone_form_deliverer_header':
      'Antes de acessar a rota de entrega, insira seu número de WhatsApp',
  'phone_form_supplier_header':
      'Parceiro, acesse sua conta com seu número de WhatsApp',
  'confirmation_code_form_header': 'Digite o código de confirmação'
};

final _subHeaders = {
  'delivery_code_form_sub_header':
      'Caso não, mas deseje ver suas entregas pendentes, acesse sua conta de parceiro Trela',
  'phone_form_sub_header':
      'Digite seu WhatsApp para entrar. Seus dados estão seguros e você não precisa de senha.',
  'confirmation_code_form_sub_header':
      'Insira o código de 6 dígitos que enviamos para o seu WhatsApp :phone'
};

final _listTitles = {
  'supplier_data': 'Dados da empresa',
};

final _listContent = {
  'delivery_list_no_deliveries': 'Nenhuma entrega encontrada',
  'delivery_created_subtitle': 'Entrega prevista: dia :day às :hour horas',
  'delivery_in_progress_subtitle': 'Entrega prevista: dia :day às :hour horas',
  'delivery_finished_subtitle': 'Entregue: dia :day às :hour horas',
  'delivery_initial_address': 'Endereço inicial: :address',
  'delivery_estimate_time': 'Tempo estimado: :hour horas e :minute minutos',
};

final _inputLabels = {
  'delivery_code_input_label': 'Código de 6 dígitos',
  'phone_input_label': 'Telefone',
  'confirmation_code_input_label': 'Código de 5 dígitos'
};

final _inputHints = {
  'code_input_hint': 'Código',
  'phone_input_hint': 'Telefone completo',
};

final _formValidation = {
  'empty_delivery_code_input_error': 'Digite o código de entrega',
  'invalid_delivery_code_input_error': 'Código de entrega invalido',
  'invalid_phone_input_error': 'Insira um telefone válido',
  'empty_confirmation_code_input_error': 'Digite o código de confirmação',
  'invalid_confirmation_code_input_error': 'Código de confirmação invalido',
};

final _buttonLabels = {
  'verify_code_button': 'Verificar código de entrega',
  'trela_partner_button': 'Sou um parceiro trela',
  'phone_form_deliverer_button': 'Ver detalhes da entrega',
  'phone_form_supplier_button': 'Receber código por WhatsApp',
  'confirmation_code_button': 'Verificar',
  'resend_code_button': 'Reenviar código',
  'change_number_button': 'Trocar número de celular',
  'exit_button': 'Sair',
  'share_delivery_with_deliverer': 'Enviar para Entregador',
  'start_delivery': 'Iniciar entrega',
  'cancel_delivery': 'Cancelar entrega',
  'cancel': 'Cancelar',
  'confirm': 'Confirmar'
};

final _alerts = {
  'phone_not_registered_error':
      'Este telefone não possuí uma conta de parceiro Trela.',
  'invalid_confirmation_code_error':
      'Código inválido. Verifique-o e tente novamente',
  'generic_error_msg': 'Ocorreu um erro, tente novamente mais tarde.',
  'resend_code_success_message':
      'Código de autenticação reenviado com sucesso.',
  'location_permission_error':
      'Para realizar a entrega precisamos de sua localização. Por favor habilite a localização.',
};

final _tabs = {
  'pending': 'Pendentes',
  'in_progress': 'Em andamento',
  'delivered': 'Entregues',
  'products': 'Produtos',
  'orders': 'Pedidos'
};

final _shareMessages = {
  'share_with_deliverer':
      'Olá, aqui está o código de acesso à entrega :name: :code'
};

final _dialogTitles = {
  'start_delivery_dialog_title':
      'Você tem certeza que deseja iniciar essa entrega?',
  'cancel_delivery_dialog_title':
      'Você tem certeza que deseja cancelar essa entrega?',
};

final Map<String, String> ptBR = {
  ..._appBarTitles,
  ..._headers,
  ..._subHeaders,
  ..._listTitles,
  ..._listContent,
  ..._inputLabels,
  ..._inputHints,
  ..._formValidation,
  ..._buttonLabels,
  ..._alerts,
  ..._tabs,
  ..._shareMessages,
  ..._dialogTitles
};
