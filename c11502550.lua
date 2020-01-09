--E・HERO エアー・ネオス
function c11502550.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,89943723,54959865,false,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD,0,aux.tdcfop(c))
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11502550.splimit)
	c:RegisterEffect(e1)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11502550,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c11502550.retcon1)
	e3:SetTarget(c11502550.rettg)
	e3:SetOperation(c11502550.retop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0)
	e4:SetCondition(c11502550.retcon2)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c11502550.atkval)
	c:RegisterEffect(e5)
end
c11502550.material_setcode=0x8
c11502550.neos_fusion=true
function c11502550.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c11502550.retcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(42015635)
end
function c11502550.retcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(42015635)
end
function c11502550.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c11502550.retop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c11502550.atkval(e,c)
	local lps=Duel.GetLP(c:GetControler())
	local lpo=Duel.GetLP(1-c:GetControler())
	if lps>=lpo then return 0
	else return lpo-lps end
end
