--トラックブラック
function c66226132.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	c:EnableReviveLimit()
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66226132,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,66226132)
	e1:SetTarget(c66226132.target)
	e1:SetOperation(c66226132.operation)
	c:RegisterEffect(e1)
end
function c66226132.tgfilter(c,lg)
	return lg:IsContains(c)
end
function c66226132.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66226132.tgfilter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(c66226132.tgfilter,tp,LOCATION_MZONE,0,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c66226132.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,lg)
end
function c66226132.operation(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	tc:RegisterFlagEffect(66226132,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(66226132,1))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetLabelObject(tc)
	e1:SetCondition(c66226132.drcon)
	e1:SetOperation(c66226132.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c66226132.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(66226132)~=0
end
function c66226132.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,66226132)
	Duel.Draw(tp,1,REASON_EFFECT)
end
