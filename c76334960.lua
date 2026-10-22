--召喚魔術－「杯」
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function s.fusfilter(c)
	return c:IsSetCard(0xf4)
end
function s.fcheck1(tp,mg,fc,mg_all)
	return mg_all:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_ONFIELD)==1
		and mg_all:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==1
end
function s.fcheck2(tp,mg,fc,mg_all)
	return mg_all:FilterCount(Card.IsControler,nil,tp)==1
		and mg_all:FilterCount(Card.IsControler,nil,1-tp)==1
end
function s.CreateFusionEffect1(c)
	return FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_MZONE|LOCATION_DECK,
		additional_fcheck=s.fcheck1,
		mat_operation_code_map={
			{[LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE},
			{[0xff]=FusionSpell.FUSION_OPERATION_BANISH}
		}
	})
end
function s.CreateFusionEffect2(c)
	return FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_MZONE,
		pre_select_mat_opponent_location=LOCATION_MZONE,
		additional_fcheck=s.fcheck2,
		mat_operation_code_map={
			{[LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE},
			{[0xff]=FusionSpell.FUSION_OPERATION_BANISH}
		}
	})
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fe1=s.CreateFusionEffect1(c)
	local fe2=s.CreateFusionEffect2(c)
	local res1=fe1:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
	local res2=fe2:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return res1 or res2 end
	local op=aux.SelectFromOptions(tp,
			{res1,aux.Stringid(id,1),1},
			{res2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		s.CreateFusionEffect1(c):GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	elseif e:GetLabel()==2 then
		s.CreateFusionEffect2(c):GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	end
end
