--混沌幻魔アーミタイル－虚無幻影羅生悶
---@param c Card
function c60110982.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,6007213,32491822,69890967,true,true)
	--change name
	aux.EnableChangeCode(c,43378048)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60110982,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c60110982.cttg)
	e2:SetOperation(c60110982.ctop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CONTROL_CHANGED)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c60110982.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60110982,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c60110982.rmcon)
	e4:SetTarget(c60110982.rmtg)
	e4:SetOperation(c60110982.rmop)
	c:RegisterEffect(e4)
end
function c60110982.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c60110982.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,1-tp)
	end
end
function c60110982.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(60110982,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c60110982.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(60110982)>0
end
function c60110982.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c60110982.spfilter(c,e,p)
	return c:IsCode(43378048) and c:IsCanBeSpecialSummoned(e,0,p,true,false) and Duel.GetLocationCountFromEx(p,p,nil,c)>0
end
function c60110982.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED)
		and Duel.IsExistingMatchingCard(c60110982.spfilter,p,LOCATION_EXTRA,0,1,nil,e,p) and Duel.SelectYesNo(p,aux.Stringid(60110982,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(p,c60110982.spfilter,p,LOCATION_EXTRA,0,1,1,nil,e,p)
		Duel.SpecialSummon(sg,0,p,p,true,false,POS_FACEUP)
	end
end
