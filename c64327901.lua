--百鬼羅刹大集会
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xac))
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--extra normal summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xac))
	c:RegisterEffect(e2)
	--change level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xac)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
function s.lvfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0xac) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsCanBeEffectTarget(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,0,2,nil,e) end
	local g=Duel.SelectTarget(tp,s.lvfilter,tp,LOCATION_MZONE,0,2,2,nil,e)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local lv1=tc1:GetLevel()
	local lv2=tc2:GetLevel()
	local op=aux.SelectFromOptions(tp,{lv1~=lv2,aux.Stringid(id,2)},{true,aux.Stringid(id,3)})
	e:SetLabel(op)
end
function s.tgfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.tgfilter,nil,e)
	if g:GetCount()<2 then return end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local lv1=tc1:GetLevel()
	local lv2=tc2:GetLevel()
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
		local g1=g:Select(tp,1,1,nil)
		local lv=g1:GetFirst():GetLevel()
		local sc=(g-g1):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	else
		local tc=g:GetFirst()
		while tc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(lv1+lv2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
		end
	end
end