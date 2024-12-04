--騎甲虫ライト・フラッパー
function c88962829.initial_effect(c)
	--add
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88962829,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,88962829)
	e1:SetTarget(c88962829.thtg)
	e1:SetOperation(c88962829.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88962829,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,88962830)
	e3:SetCondition(c88962829.atkcon)
	e3:SetTarget(c88962829.atktg)
	e3:SetOperation(c88962829.atkop)
	c:RegisterEffect(e3)
end
function c88962829.thfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x170) and c:IsAbleToHand()
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and c:IsCanBeEffectTarget(e)
end
function c88962829.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c88962829.thfilter(chkc,e) end
	local g=Duel.GetMatchingGroup(c88962829.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,#g1,0,0)
end
function c88962829.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local tg=g:Filter(c88962829.check,nil,tp)
		if #tg<=0 then return end
		Duel.ConfirmCards(1-tp,tg)
		local code_table={}
		for tc in aux.Next(tg) do
			local codes={tc:GetCode()}
			for i=1,#codes do
				table.insert(code_table,codes[i])
			end
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetLabel(table.unpack(code_table))
		e1:SetValue(c88962829.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c88962829.check(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function c88962829.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c88962829.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(1-tp)
end
function c88962829.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c88962829.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) then
		Duel.NegateAttack()
	end
end
