--DDD聖賢王アルフレッド
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xaf),2,true)
	c:EnableReviveLimit()
	--fusion
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_MZONE|LOCATION_REMOVED,
		mat_operation_code_map={
			{[LOCATION_DECK]=FusionSpell.FUSION_OPERATION_GRAVE},
			{[0xff]=FusionSpell.FUSION_OPERATION_SHUFFLE}
		},
		extra_target=s.extra_target
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.tftg)
	e2:SetOperation(s.tfop)
	c:RegisterEffect(e2)
end
function s.fusfilter(c)
	return c:IsSetCard(0x10af)
end
function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk~=0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_REMOVED)
	end
end
function s.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xae) and c:IsFaceupEx() and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10af)
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.tffilter(chkc,tp) end
	local count1=Duel.GetTargetCount(s.tffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,tp)
	local count2=Duel.GetMatchingGroupCount(s.mfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and count1>0 and count2>0 end
	local ct=math.min((Duel.GetLocationCount(tp,LOCATION_SZONE)),count1,count2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,s.tffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil,tp)
	local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if gg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,gg,gg:GetCount(),0,0)
	end
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	local sct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ct=math.min(g:GetCount(),sct)
	local pg=g
	if ct<=0 then
		pg=Group.CreateGroup()
	elseif g:GetCount()>ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		pg=g:Select(tp,ct,ct,nil)
		g:Sub(pg)
	else
		g=Group.CreateGroup()
	end
	for tc in aux.Next(pg) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	local sg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
