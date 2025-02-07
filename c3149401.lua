--誇りと魂の究極竜
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,s.ffilter,3,true)
	c:EnableReviveLimit()
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.indcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(s.atkcon)
	e3:SetValue(4500)
	c:RegisterEffect(e3)
	--def up
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.descon)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
end
function s.ffilter(c)
	return c:GetBaseAttack()==2500 and c:GetBaseDefense()==2500
end
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function s.atkcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_GRAVE,0)>=25
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_GRAVE)>=25
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
