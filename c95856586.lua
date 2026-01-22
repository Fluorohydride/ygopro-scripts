--ゼアル・フィールド
function c95856586.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c95856586.chainop)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95856586,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,95856586)
	e3:SetTarget(c95856586.mattg)
	e3:SetOperation(c95856586.matop)
	c:RegisterEffect(e3)
	--deck top
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95856586,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PREDRAW)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c95856586.tdcon)
	e4:SetTarget(c95856586.tdtg)
	e4:SetOperation(c95856586.tdop)
	c:RegisterEffect(e4)
end
function c95856586.cfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c95856586.chainop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if tg and tg:IsExists(c95856586.cfilter,1,nil,tp) and ep==tp then
		Duel.SetChainLimit(c95856586.chainlm)
	end
end
function c95856586.chainlm(e,rp,tp)
	return tp==rp
end
function c95856586.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_XYZ)
		and c:IsLocation(LOCATION_MZONE) and c:IsCanBeEffectTarget(e)
end
function c95856586.matfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsCanOverlay()
end
function c95856586.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c95856586.tgfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c95856586.tgfilter,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c95856586.matfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	local g=eg
	if #eg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=eg:FilterSelect(tp,c95856586.tgfilter,1,1,nil,e,tp)
	end
	Duel.SetTargetCard(g)
end
function c95856586.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95856586.matfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c95856586.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c95856586.tdfilter(c)
	return c:IsCode(35906693)
end
function c95856586.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
		and Duel.IsExistingMatchingCard(c95856586.tdfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c95856586.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(95856586,2))
	local dc=Duel.SelectMatchingCard(tp,c95856586.tdfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if dc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(dc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end
