--サイバネット・コーデック
function c60018643.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60018643,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c60018643.thcon)
	e2:SetTarget(c60018643.thtg)
	e2:SetOperation(c60018643.thop)
	c:RegisterEffect(e2)
	if not c60018643.global_check then
		c60018643.global_check=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetOperation(c60018643.clear)
		Duel.RegisterEffect(e3,0)
	end
end
c60018643.attlimit=0
function c60018643.clear(e,tp,eg,ep,ev,re,r,rp)
	c60018643.attlimit=0
end
function c60018643.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x101) and c:IsControler(tp) and bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0
end
function c60018643.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60018643.cfilter,1,nil,tp)
end
function c60018643.tgfilter(c,tp,eg)
	return eg:IsContains(c) and Duel.IsExistingMatchingCard(c60018643.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c60018643.thfilter(c,att)
	local lim=c60018643.attlimit
	return c:IsRace(RACE_CYBERSE) and c:IsAttribute(att) and (lim==0 or not c:IsAttribute(lim)) and c:IsAbleToHand()
end
function c60018643.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60018643.tgfilter(chkc,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(c60018643.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp,eg)
		and Duel.GetFlagEffect(tp,60018643)==0 end
	Duel.RegisterFlagEffect(tp,60018643,RESET_CHAIN,0,1)
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c60018643.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60018643.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local att=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60018643.thfilter,tp,LOCATION_DECK,0,1,1,nil,att)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			c60018643.attlimit=c60018643.attlimit+att
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60018643.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60018643.splimit(e,c)
	return not c:IsRace(RACE_CYBERSE) and c:IsLocation(LOCATION_EXTRA)
end
