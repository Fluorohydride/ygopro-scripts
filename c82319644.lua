--邪王トラカレル
---@param c Card
function c82319644.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82319644,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c82319644.descon)
	e1:SetTarget(c82319644.destg)
	e1:SetOperation(c82319644.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c82319644.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c82319644.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:GetMaterialCount()>0
end
function c82319644.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c82319644.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c82319644.desfilter,tp,0,LOCATION_MZONE,1,nil,atk) end
	local g=Duel.GetMatchingGroup(c82319644.desfilter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c82319644.fselect(g,atk)
	return g:GetSum(Card.GetAttack)<=atk
end
function c82319644.desop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	local g=Duel.GetMatchingGroup(c82319644.desfilter,tp,0,LOCATION_MZONE,nil,atk)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:SelectSubGroup(tp,c82319644.fselect,false,1,g:GetCount(),atk)
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c82319644.valcheck(e,c)
	local atk=0
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	while tc do
		atk=atk+math.max(tc:GetTextAttack(),0)
		tc=g:GetNext()
	end
	e:GetLabelObject():SetLabel(atk)
end
