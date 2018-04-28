--創星神 sophia
function c4335427.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c4335427.spcon)
	e1:SetOperation(c4335427.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4335427,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c4335427.rmtg)
	e4:SetOperation(c4335427.rmop)
	c:RegisterEffect(e4)
end
function c4335427.spcostfilter(c)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
c4335427.spcost_table={TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ}
function c4335427.spcost_selector(c,tp,g,sg,i)
	if not c:IsType(c4335427.spcost_table[i]) then return false end
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<4 then
		flag=g:IsExists(c4335427.spcost_selector,1,nil,tp,g,sg,i+1)
	else
		flag=Duel.GetMZoneCount(tp,sg,tp)>0
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c4335427.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c4335427.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Group.CreateGroup()
	return g:IsExists(c4335427.spcost_selector,1,nil,tp,g,sg,1)
end
function c4335427.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c4335427.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Group.CreateGroup()
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=g:FilterSelect(tp,c4335427.spcost_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c4335427.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0x1e,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c4335427.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0x1e,aux.ExceptThisCard(e))
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
