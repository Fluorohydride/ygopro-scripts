--粛星の鋼機
function c32986898.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK)),3,3)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c32986898.atkcon)
	e1:SetOperation(c32986898.atkop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32986898,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,32986898)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c32986898.destg)
	e2:SetOperation(c32986898.desop)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c32986898.valcheck)
	c:RegisterEffect(e4)
	e4:SetLabelObject(e1)
end
function c32986898.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c32986898.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local atk=0
	local tc=g:GetFirst()
	while tc do
		local lk
		if tc:IsType(TYPE_XYZ) then
			lk=tc:GetOriginalRank()
		else
			lk=tc:GetOriginalLevel()
		end
		atk=atk+lk
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk*100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	if e:GetLabel()==1 then
		c:RegisterFlagEffect(32986898,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c32986898.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and not c:IsType(TYPE_LINK)
end
function c32986898.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c32986898.desfilter(chkc,c:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c32986898.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c32986898.desfilter,tp,0,LOCATION_MZONE,1,1,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c32986898.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():GetFlagEffect(32986898)~=0 then
			local atk=tc:GetBaseAttack()
			if atk>0 then
				Duel.BreakEffect()
				Duel.Damage(1-tp,math.ceil(atk/2),REASON_EFFECT)
			end
		end
	end
end
function c32986898.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkType,1,nil,TYPE_XYZ) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
