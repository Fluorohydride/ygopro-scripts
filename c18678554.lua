--クロノダイバー・フライバック
function c18678554.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18678554,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18678554)
	e1:SetTarget(c18678554.target)
	e1:SetOperation(c18678554.activate)
	c:RegisterEffect(e1)
	--grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18678554,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,18678554)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c18678554.mattg)
	e2:SetOperation(c18678554.matop)
	c:RegisterEffect(e2)
end
function c18678554.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x126)
end
function c18678554.matfilter(c)
	return c:IsSetCard(0x126) and c:IsCanOverlay()
end
function c18678554.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c18678554.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18678554.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c18678554.matfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c18678554.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c18678554.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c18678554.matfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c18678554.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c18678554.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18678554.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c18678554.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c18678554.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
		if aux.NecroValleyNegateCheck(g) then return end
		local tg=g:FilterSelect(tp,Card.IsCanOverlay,1,1,nil)
		if #tg>0 then
			Duel.Overlay(tc,tg)
		end
	end
end
